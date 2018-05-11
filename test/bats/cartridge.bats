#!/usr/bin/env bats

setup() {

  mkdir /tmp/adopctest
  cd /tmp/adopctest

}

teardown() {

  rm -rf /tmp/adopctest

}


@test "Subcommand help should display help" {
  run adop cartridge help
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "usage: adop cartridge <subcommand>" ]
}

@test "Passing -h and no subcommand should display help" {
  run adop cartridge -h
  [ "$status" -eq 1 ]
  [ "${lines[1]}" = "usage: adop cartridge <subcommand>" ]
}


@test "Passing -h to init subcommand should display help" {
  run adop cartridge init -h
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "usage: adop cartridge init [<options>]"* ]]
}

@test "Subdir containing .. not allowed for init" {
  run adop cartridge init -s ..
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "ERROR: the cartridge subdirectory name must not contain '..'." ]
}

@test "Subdir starting with / not allowed for init" {
  run adop cartridge init -s /bob
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "ERROR: the cartridge subdirectory name must not be supplied as an absolute path." ]
}

@test "Supplying both a template name and template cartridge git url isn't supported for init" {
  run adop cartridge init -t a -c b
  [ "$status" -eq 1 ]
  [[ "${lines[0]}" == "ERROR: Both a template name "* ]]
}

@test "Supplying a template we don't support should fail" {
  run adop cartridge init -t not_a_real_template
  [ "$status" -eq 1 ]
  [[ "${lines[0]}" == *"type not yet supported"* ]]
}

@test "Normal run should produce a folder called adop" {
  run adop cartridge init
  echo ${output}
  [ "$status" -eq 0 ]
  [ -d "adop" ]
}

@test "All template URLs still exist" {
  templates=`adop cartridge list_template_urls`
  results=`for URL in $templates; do curl --output /dev/null --silent --head --fail $URL; printf $?; done`
  run bash -c "echo $results | grep \"^0\+$\""
  [ "$status" -eq 0 ]
}


