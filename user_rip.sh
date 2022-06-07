#!/bin/bash

if [[ -z $(which python3) ]]; then
  exit "You must install python3 first: https://www.python.org/downloads/"
fi

if [[ -z $(pip --version) ]]; then
  exit "install pip 3, download https://bootstrap.pypa.io/get-pip.py and run 'python3 get-pip.py'"
fi

if [[ -z $(pip3 show scdl) ]]; then
  pip3 install scdl
fi

##############
# PARSE ARGS #
##############
SCDL_TARGET="$1"
shift
SCDL_ADD_ARGS="$@"
SCDL_TARGET_DIR="$(pwd)/$SCDL_TARGET"

#######################################################################
# PREFIX AND SUFFIX COMMANDS, MAKE CHANGES TO PARAMS MOST LIKELY HERE #
#######################################################################
SCDL_PREFIX="scdl -l https://soundcloud.com/$SCDL_TARGET"
SCDL_SUFFIX="-c --addtofile --min-size 1.8m --max-size 25m"

echo -e "Downloading everything from $SCDL_TARGET to $SCDL_TARGET_DIR . . . . \n\n"

mkdir -p $SCDL_TARGET_DIR


#######################################
# FLAG PAIRS FOR THE SEPARETE SUBDIRS #
#######################################
SCDL_FLAGS=( "uploads:t" "favorites:f" "commented:C" "playlists:p" )

########################################
# RUNNING DOWNLOADS FOR EACHS CATEGORY #
########################################
for SCDL_FLAG_PAIR in "${SCDL_FLAGS[@]}"; do 
  SCDL_FLAG=$(echo $SCDL_FLAG_PAIR | cut -f2 -d":")
  SCDL_TYPE=$(echo $SCDL_FLAG_PAIR | cut -f1 -d":")

  SCDL_TARGET_TYPE_DIR=$SCDL_TARGET_DIR/$SCDL_TYPE
  SCDL_TARGET_TYPE_ARCHIVE=$SCDL_TARGET_TYPE_DIR/archive.txt
  mkdir -p $SCDL_TARGET_TYPE_DIR
  
  SCDL_CMD="$SCDL_PREFIX -$SCDL_FLAG --path $SCDL_TARGET_TYPE_DIR --download-archive $SCDL_TARGET_TYPE_ARCHIVE $SCDL_SUFFIX $SCDL_ADD_ARGS"
  
  echo "$SCDL_CMD"
  eval $SCDL_CMD
done
