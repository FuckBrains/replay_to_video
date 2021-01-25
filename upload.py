import argparse
from youtube_uploader_selenium import YouTubeUploader
from typing import Optional


def main(video_path: str, metadata_path: Optional[str] = None):
    uploader = YouTubeUploader(video_path, metadata_path)
    was_video_uploaded, video_id = uploader.upload()
    assert was_video_uploaded


if __name__ == "__main__":
    video_path = 'replay.mkv'
    metadata_path = 'metadata.json'
    main(video_path, metadata_path)
