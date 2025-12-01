import mido
import math

path = "erika.mid"

def MidiConvert(path):
    mid = mido.MidiFile(path, clip=True)
    print(mid)
    useconds_per_beat = 0
    song_name = "Unknown"
    tempo_bpm = -1
    ms_per_tick = -1
    ticks_per_beat = mid.ticks_per_beat

    # Parse header trunk
    for msg in mid.tracks[0]:
        if msg.is_meta:
            print(msg)
            if msg.type == 'set_tempo':
                useconds_per_beat = msg.tempo
            elif msg.type == 'track_name':
                song_name = msg.name

    # https://www.recordingblogs.com/wiki/time-division-of-a-midi-file
    # 1tick = microsecondsPerBeat/ticksPerBeat in microseconds
    us_per_tick = (useconds_per_beat/ticks_per_beat) 

    # set up song structure
    song_pitches = []
    song_durations = []

    # parse music (track) trunk
    for track in mid.tracks:#[1:]:
        for msg in track:
            if msg.type == 'note_on':
                song_pitches.append((msg.note if msg.velocity != 0 else 0))
                song_durations.append(round(msg.time*us_per_tick))
            elif msg.type == 'note_off':
                song_pitches.append(0)
                song_durations.append(round(msg.time*us_per_tick))
    
    song_durations.append(song_durations[len(song_durations)-1])
    return song_pitches, song_durations[1:]


if __name__ == "__main__":
    song_pitches, songdurations = MidiConvert(path)
    print(song_pitches[12:])
    print(songdurations[12:])