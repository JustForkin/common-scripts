function usage {
  while true; do free | awk {'print $3'} | head -3 | tail -1 >> free.dat; sleep 0.5; done
}

function ps_mem {
  pushd $HOME/ps_mem
  sudo python ps_mem.py -p $@
  popd
}

function ps_test {
  ps_mem $(pidof $@ | tr '\ ' ',')
}
