import os
from urllib.parse import unquote
from gi.repository import GObject, Nautilus
from typing import List
from pymediainfo import MediaInfo


class ColumnExtension(GObject.GObject, Nautilus.ColumnProvider, Nautilus.InfoProvider):
    VALID_MIMETYPES = ("video/x-matroska")

    def get_columns(self) -> List[Nautilus.Column]:
        column = Nautilus.Column(
            name="NautilusPython::media_duration",
            attribute="media_duration",
            label="Duration",
            description="Get the media duration",
        )

        return [
            column,
        ]

    def update_file_info(self, file: Nautilus.FileInfo) -> None:
        if file.get_uri_scheme() != "file":
            return

        if file.get_mime_type() not in self.VALID_MIMETYPES:
            return

        filename = unquote(file.get_uri()[7:])
        media_info = MediaInfo.parse(filename)

        try:
            video = media_info.video_tracks[0]
            duration = int(float(video.duration) / 1000)
            seconds = duration % 60
            minutes = int(duration / 60)
            out = "{:0>2}:{:0>2}".format(minutes, seconds)
            file.add_string_attribute("media_duration", out)
        except Exception as ex:
            file.add_string_attribute("media_duration", str(ex))
