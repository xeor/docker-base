# Info
* The official `centos` image is the parent.

# Versions / tags / changelog
Each tag in this repository is getting build as it's corresponding docker-tag. The tagname `7.1-2` means that we use centos7 base, updated to 7.1, and it's our 2nd build.

* 2015-11-18 - `7.1-1`: Intitial version

# Ideas
* Daemon-mode (supervisord) if we find supervisord files
* supervisord conf, so we dont need to guess where the .sock file is
* runas / uid user can be specified using ENV
* Hooks directory, a place where we look for files to run on startup. Example when supervisord is ready.
* Default supervisord output from apps should be redirected to containers stdout, so docker logs will show it. Maybe with an app prefix
