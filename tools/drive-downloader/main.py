import os
import re
from pathlib import Path

import click
import gdown

DEFAULT_PREFIX = os.environ.get('DD_DEFAULT_PREFIX', '/home/server/media')


class DriveObject:
    def __init__(self, url: str, download_location: str):
        self.url = url
        self.download_location = download_location

        # Maybe add default prefix
        if not self.download_location.startswith('/'):
            self.download_location = f'{DEFAULT_PREFIX}/{self.download_location}'

        # Maybe download is folder without slash
        if not self.download_location.endswith('/'):
            if self.download_location[-4] != '.':
                self.download_location += '/'

    def is_folder(self):
        return 'folder' in self.url

    def is_fuzzy(self):
        return 'https' in self.url or '/file/d' in self.url

    def download(self):
        fn = gdown.download_folder if self.is_folder() else gdown.download
        kwargs = dict(url=self.url, output=self.download_location)
        if not self.is_folder():
            kwargs['fuzzy'] = self.is_fuzzy()
        else:
            kwargs['remaining_ok'] = True
        self._maybe_create_location()
        fn(**kwargs)

    def _maybe_create_location(self):
        p = Path(self.download_location)
        has_extension = re.match(r'.*\.\w{3}', self.download_location) is not None
        if not has_extension:
            p.mkdir(parents=True, exist_ok=True)


@click.command()
@click.option('--directory',
              default='.',
              help='Root directory with .drive files.')
@click.option('--max_files',
              default=-1,
              help='Maximum number of objects to download (-1=disable).')
def main(directory: str, max_files: int):
    directory = Path(directory)
    assert directory.exists(), "Diretório inexistente."
    skip_max = (max_files == -1)

    for f in sorted(directory.rglob('*.drive'), key=lambda p: p.name):
        if max_files > 0 or skip_max:
            print(f'\033[1;33mStarting {f.name}...')
            data = f.read_text().strip().split('\n')
            dl = data.pop(0)
            for url in data:
                obj = DriveObject(url=url, download_location=dl)
                obj.download()
            f.unlink()
            max_files -= 1
            print(f'\033[0;32mFinished {f.name}')
        else:
            break


if __name__ == '__main__':
    main()
