#!/usr/bin/env python3
"""
Generates a minimal FIT activity file with a fake cycling GPS route
for use with the Garmin CIQ simulator (Simulation > FIT File).

Route: a small loop in Munich (Englischer Garten), ~1.2 km.
"""
import struct, zlib, math, os

# FIT CRC lookup table
CRC_TABLE = [
    0x0000, 0xCC01, 0xD801, 0x1400, 0xF001, 0x3C00, 0x2800, 0xE401,
    0xA001, 0x6C00, 0x7800, 0xB401, 0x5000, 0x9C01, 0x8801, 0x4400,
]

def fit_crc(data, crc=0):
    for byte in data:
        tmp = CRC_TABLE[crc & 0xF]
        crc = (crc >> 4) & 0x0FFF
        crc ^= tmp ^ CRC_TABLE[byte & 0xF]
        tmp = CRC_TABLE[crc & 0xF]
        crc = (crc >> 4) & 0x0FFF
        crc ^= tmp ^ CRC_TABLE[(byte >> 4) & 0xF]
    return crc

def deg_to_semicircles(deg):
    return int(deg * (2**31 / 180.0))

# FIT epoch: seconds since 1989-12-31 00:00:00 UTC
# Use a fixed start time (doesn't matter for simulation)
FIT_EPOCH_OFFSET = 631065600  # Unix timestamp of FIT epoch
START_TIME = 1000000000 - FIT_EPOCH_OFFSET  # arbitrary past time in FIT ts

def make_definition(local_num, global_num, fields):
    """fields = list of (field_def_num, size, base_type)"""
    header = 0x40 | local_num  # definition message header
    body = struct.pack('>BH', 0, global_num)  # reserved=0, global mesg num (big-endian)
    body += struct.pack('B', len(fields))
    for fdn, size, btype in fields:
        body += struct.pack('BBB', fdn, size, btype)
    return bytes([header]) + body

def make_data(local_num, fmt, values):
    header = local_num  # data message header
    body = struct.pack(fmt, *values)
    return bytes([header]) + body

def build_fit(waypoints):
    data = bytearray()

    # --- Definition: file_id (global 0) ---
    # field 0=type(1B), 1=manufacturer(2B), 2=product(2B), 4=time_created(4B)
    data += make_definition(0, 0, [
        (0, 1, 0),   # type, uint8
        (1, 2, 132), # manufacturer, uint16
        (2, 2, 132), # product, uint16
        (4, 4, 134), # time_created, uint32
    ])
    data += make_data(0, '<BHHHI', (4, 1, 1, 0, START_TIME))
    # type=4 (activity), manufacturer=1, product=1, serial=0, time_created

    # --- Definition: event (global 21) ---
    # field 0=event(1B), 1=event_type(1B), 253=timestamp(4B)
    data += make_definition(1, 21, [
        (253, 4, 134), # timestamp, uint32
        (0,   1, 0),   # event, uint8
        (1,   1, 0),   # event_type, uint8
    ])
    # start event (event=0 timer, event_type=0 start)
    data += make_data(1, '<IBB', (START_TIME, 0, 0))

    # --- Definition: record (global 20) ---
    # field 253=timestamp(4B), 0=lat(4B sint32), 1=lon(4B sint32), 6=speed(2B uint16)
    data += make_definition(2, 20, [
        (253, 4, 134), # timestamp, uint32
        (0,   4, 133), # position_lat, sint32
        (1,   4, 133), # position_long, sint32
        (6,   2, 132), # speed, uint16 (mm/s * 1000)
    ])

    for i, (lat, lon) in enumerate(waypoints):
        ts = START_TIME + i * 2  # one point every 2 seconds
        sc_lat = deg_to_semicircles(lat)
        sc_lon = deg_to_semicircles(lon)
        speed = 5000  # ~18 km/h in mm/s
        data += make_data(2, '<Iiih', (ts, sc_lat, sc_lon, speed))

    # --- Definition: session (global 18) ---
    data += make_definition(3, 18, [
        (253, 4, 134), # timestamp
        (2,   4, 134), # start_time
        (5,   4, 134), # total_elapsed_time (ms * 1000)
        (7,   2, 132), # total_distance (cm)
        (0,   1, 0),   # event
        (1,   1, 0),   # event_type
        (8,   1, 0),   # sport
    ])
    end_ts = START_TIME + len(waypoints) * 2
    data += make_data(3, '<IIIHBBb', (
        end_ts, START_TIME,
        len(waypoints) * 2 * 1000,  # elapsed_time in ms
        1200,  # total_distance in cm (~12m, placeholder)
        9, 1, 2  # event=session, event_type=stop, sport=cycling
    ))

    # --- stop event ---
    data += make_data(1, '<IBB', (end_ts, 9, 1))

    data = bytes(data)

    # Build header
    data_crc = fit_crc(data)
    header_payload = struct.pack('<BBHI4s',
        14,       # header size
        0x10,     # protocol version 1.0
        2132,     # profile version
        len(data),
        b'.FIT'
    )
    header_crc = fit_crc(header_payload)
    header = header_payload + struct.pack('<H', header_crc)

    return header + data + struct.pack('<H', data_crc)


# Fake cycling route: small loop near Englischer Garten, Munich
# Starting point: ~48.1570 N, 11.5880 E, heading roughly east then south
waypoints = []
base_lat, base_lon = 48.1570, 11.5880
num_points = 120  # 4 minutes @ 2s intervals

for i in range(num_points):
    t = i / num_points
    # Simple figure-8-ish route using parametric circle
    angle = t * 2 * math.pi
    lat = base_lat + 0.003 * math.sin(angle)
    lon = base_lon + 0.005 * math.cos(angle) * math.sin(angle)
    waypoints.append((lat, lon))

out_path = os.path.join(os.path.dirname(__file__), "test_route.fit")
fit_data = build_fit(waypoints)
with open(out_path, 'wb') as f:
    f.write(fit_data)

print(f"Written {len(fit_data)} bytes to {out_path}")
print(f"Route: {num_points} points, ~{num_points * 2}s duration")
print(f"Start: {waypoints[0][0]:.5f}, {waypoints[0][1]:.5f}")
print()
print("Load in simulator: Simulation > FIT File > select test_route.fit")
PYEOF