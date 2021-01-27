import sys
from sys import platform
from pathlib import Path
from subprocess import check_call, STDOUT
from shutil import which
from unittest import TestCase
import pytest


isWin = platform == 'win32'


class TestExamples(TestCase):

    def setUp(self):
        self.shell = [which('bash')] if platform == 'win32' else []
        self.root = Path(__file__).parent

        sys.stdout.flush()

    def tearDown(self):
        sys.stdout.flush()


    def _sh(self, args):
        check_call(self.shell + args, stderr=STDOUT)


    def test_vhpidirect_quickstart_random(self):
        self._sh([str(self.root / 'test-abort' / 'run.sh')])

