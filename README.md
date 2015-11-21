# Info
* The official `centos` image is the parent.

# Usage
Use `FROM xeor/base` on top of your `Dockerfile` to use this base-image.

## Environment variables
* `DOCKER_DEBUG`: Sets docker-startup scripts in debugger mode (`set -x` and so on), and print some extra information regarding startup.
* `DEPENDING_ENVIRONMENT_VARS`: We wont start before we got all variables listed here (space separated list). We will also give an error listing the missing variables.
* `SUPERVISORD_LOGLEVEL`: Supervisord loglevel, defaults to `error`.
* `SUPERVISORD_WAIT_TIME`: How long between each time we check if supervisord is alive and ready. Defaults to `0.2`
* `SUPERVISORD_CHECK_EVERY`: Check if supervisord is alive ever `X` times. Defaults to `5`.
* `SUPERVISORD_MAX_START_TRIES`: How many times should we check if supervisord have started before we give up. `0` is unlimited and default.
* `DUID`: The UID of the already existing `docker` user.
* `DGID`: The GID of the already existing `docker` group.

## User
There is a user created as default called `docker` belonging to a group called `docker`, both with GID and GID of `950`.
We are not using it for anything as default, it is ment for in your supervisord.ini files, CMD, etc. You can change the UID and GID of this user when you start the container with setting the environment variables `DUID` and/or `DGID` to the ID you want the `docker` user/group to have.

Note that setting `USER` to `docker` in a Dockerfile, then setting `DUID` and/or `DGID` on startup, wont work. It's our entrypoint file that sets the correct ID's on the docker-user, and if you start docker with another user, we wont have access. We will start, but you will get a warning.

## Daemon-mode
If we find 1 or more `*.ini` files in `/etc/supervisord.d` we will use `supervisord` as a loader. A simple `COPY supervisord.d/ /etc/supervisord.d/` in your `Dockerfile` does the trick.
A simple `nginx.ini` might look like this (documentation is @ http://supervisord.org/configuration.html#program-x-section-settings):

    [program:nginx]
    command=/usr/sbin/nginx
    autostart=true
    autorestart=true

    # Redirect output so we can see it using "docker logs"
    stdout_logfile=/dev/stdout
    stdout_logfile_maxbytes=0
    stderr_logfile=/dev/stderr
    stderr_logfile_maxbytes=0

## Hooks
There are different hooks that is ran when we startup. This is done to make it easier to implement containers that looks the same, but example runs different supervisord configs based on an environment variable (remember to have auto_start to false).

If you want your hook to be debuggable, look for the `DOCKER_DEBUG` variable. A simple `[[ ${DOCKER_DEBUG} ]] && set -x` on top of your shell script is probably good enough.

Hooks are only ran if they are executable.

* `/hooks/entrypoint-pre`: Early in the entrypoint. Before we do anything.
* `/hooks/entrypoint-run`: Runs if `CMD` is not overridden. (ie, we are doing daemon-mode or spawns a default bash shell).
* `/hooks/entrypoint-exec`: Runs only if `CMD` is overridden. Runs just before we execute `CMD`.
* `/hooks/supervisord-pre`: Just before we fire up supervisord.
* `/hooks/supervisord-ready`: Runned after we know that supervisord is ready.

* `/init/setup`: Runs right after `entrypoint-pre`, are there for backwards compatibility and because its easy to remember. Note that this file does NOT need to be executable. We will make it +x automatically if it exists.

## Other files / folders
* `/tmp/sockets/`: An own folder for `.sock` files, if you need that. Eg, to get `overlay`-fs happy (currently no .sock file support - https://github.com/docker/docker/issues/12080).

# Versions / tags / changelog
Each tag in this repository is getting build as it's corresponding docker-tag. The tagname `7.1-2` means that we use centos7 base, updated to 7.1, and it's our 2nd build.

* `latest` is bound to the `master` branch. Careful using this :)

* Changelog
  * 2015-11-21 - `:7.1-4`: Fixing supervisorctl, it didnt work. Added sane default ENV's. `docker`-user with configurable UID/GID.
  * 2015-11-20 - `:7.1-3`: Adding `/init/setup` compatibility.
  * 2015-11-19 - `:7.1-2`: First "kinda-working" version, lots of ideas implemented and tested.
  * 2015-11-18 - `:7.1-1`: Intitial version

# Known problems
* There is an InsecurePlatformWarning that shows up when you use some python libs (like urllib3). I am looking for a way to get rid of this without installing too many dependency packages; like gcc, python-devel and so on. But currently, that have not been a priority.

# Ideas
* runas / uid user can be specified using ENV
* inotify
