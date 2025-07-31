#
# ~/.profile
#

BOOTCOUNT_CACHE=~/.local/state/bootcount

if [[ -e $BOOTCOUNT_CACHE ]]; then
	boot_times=$(cat $BOOTCOUNT_CACHE)
	((boot_times++))
else
	boot_times=$(last | grep $USER | grep "tty" -c)
fi

echo $boot_times >$BOOTCOUNT_CACHE
echo "$USER logged in ${boot_times} times!"

export MALLOC_ARENA_MAX=2
export XDG_CONFIG_HOME=$HOME/.config/
export CLANGD_FLAGS="--pch-storage=disk"
export PODMAN_COMPOSE_WARNING_LOGS=false
export CARGO_NET_GIT_FETCH_WITH_CLI=true

export LIBVA_DRIVER_NAME=iHD
export ANV_DEBUG=video-decode,video-encode
export VDPAU_DRIVER=va_gl

my_cache_dir=$HOME/code/.cache

if [ -d $my_cache_dir ]; then
	export CARGO_HOME=$my_cache_dir/cargo/
	export RUSTUP_HOME=$my_cache_dir/rustup/

	export ANSIBLE_HOME=$my_cache_dir/ansible/
	export GRADLE_USER_HOME=$my_cache_dir/gradle/
	export npm_config_cache=$my_cache_dir/npm/
	export PIXI_CACHE_DIR=$my_cache_dir/rattler/
	export PIP_CACHE_DIR=$my_cache_dir/pip/
	export JUPYTER_CONFIG_DIR=$my_cache_dir/jupyter/
	export KERAS_HOME=$my_cache_dir/keras/
	export IPYTHONDIR=$my_cache_dir/ipython/

	export PYTHON_HISTORY=$my_cache_dir/.python_history
	export NODE_REPL_HISTORY=$my_cache_dir/.node_repl_history
fi

if [ -d '/usr/share/pycharm/jbr/' ]; then
	export IDEA_JDK=/usr/share/pycharm/jbr/
	export PYCHARM_JDK=$IDEA_JDK
fi

unset boot_times my_cache_dir

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
	Hyprland >/dev/null 2>&1
fi
