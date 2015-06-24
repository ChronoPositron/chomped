# Chomped
A link shortener that:
- Avoids characters commonly misidentified in printed text
- Generates shortened URLs that differ by at least two characters
- Supports a list of words that shouldn't be present in the shortened URL
(and the addition of new words is allowed without breaking old URLs)

## Badges

[![Travis](https://img.shields.io/travis/ChronoPositron/chomped.svg)](https://travis-ci.org/ChronoPositron/chomped)
[![Code Climate](https://img.shields.io/codeclimate/github/ChronoPositron/chomped.svg)](https://codeclimate.com/github/ChronoPositron/chomped)
[![Codecov](https://img.shields.io/codecov/c/github/ChronoPositron/chomped.svg)](https://codecov.io/github/ChronoPositron/chomped)
[![Dependencies](https://img.shields.io/gemnasium/ChronoPositron/chomped.svg)](https://gemnasium.com/ChronoPositron/chomped)
[![Apache License, Version 2.0](https://img.shields.io/github/license/chronopositron/chomped.svg)](http://opensource.org/licenses/Apache-2.0)

## Status

Base backend is functional.

## Notes for developing

Make sure to set the environment variables needed in the [secrets file](config/secrets.yml).


## License

Copyright (c) 2015 ChronoPositron

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
