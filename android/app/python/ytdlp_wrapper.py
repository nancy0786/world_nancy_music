from yt_dlp import YoutubeDL

def get_audio_url(video_url):
    ydl_opts = {
        'format': 'bestaudio/best',
        'quiet': True,
        'noplaylist': True,
    }

    with YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(video_url, download=False)
        return {
            "url": info['url'],
            "title": info.get('title', ''),
            "channel": info.get('uploader', ''),
            "thumbnail": info.get('thumbnail', ''),
            "video_id": info.get('id', '')
        }
