# SVN-TO-GIT

This program can be used to migrate from SVN to GIT revision control system.


## Example Usage

### svn-authors.sh

Basic usage:
```
 ./svn-authors.sh -a authors.list -u http://path/to/svn/repository/svn_repository_name
```

In order to be usable with <code>svn-to-git.sh</code> the generated file <code>authors.list</code> should be manually adjusted to the following scheme.

Generated <code>authors.list</code>:
```
(no author) = (no author) <(no author)>
john.doe = john.doe <john.doe>
rudolf.lingens = rudolf.lingens <rudolf.lingens>
```

Adjusted <code>authors.list</code>:
```
(no author) = (no author) <(no author)>
john.doe = John Doe <john.doe@example.org>
rudolf.lingens = Rudolf Lingens <rudolf@lingens.net>
```

### svn-to-git.sh

Basic usage for SVN standard layout:
```
./svn-to-git.sh -a /path/to/authors.list -u "http://path/to/svn/repository/svn_repository_name"
```

Advanced usage for custom SVN layout and local working directory:
./svn-to-git.sh -a /path/to/authors.list -t "current" -T "releases" -b "branches" -u "http://path/to/svn/repository/svn_repository_name" -d test


## LICENSE

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see [gpl](www.gnu.org/licenses/).


## Contact

Please use the contact-form provided by github.
