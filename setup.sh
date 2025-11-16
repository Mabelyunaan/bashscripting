#!/bin/bash

#configurations
LOG_FILE="setup.log"
VENV=".venv"
GITIGNORE=".gitignore"

#colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # reset

 touch "$LOG_FILE"


log() {
        local level="$1"
        shift
        local message="$*"
        local timestamp
        timestamp=$(date '+%F %T')

        case "$level" in
                INFO) COLOR="$BLUE";;
                SUCCESS) COLOR="$GREEN";;
                WARNING) COLOR="$YELLOW";;
                ERROR) COLOR="$RED";;
                *) COLOR="$NC";;
        esac 
        echo -e "${COLOR}[$timestamp][$level]${NC} $message" | tee -a "$LOG_FILE" 
}
info () { log INFO "$*" ; }
success() { log SUCCESS "$*" ; }
warning() { log WARNING "$*" ; }
error() { log ERROR "$*" ; }

check_venv() {
     if [[ -d "$VENV" ]]; then
       warning "virtual environment exist...activating it instead"
       source ${VENV}/bin/activate
    else 
      info "creating virtual environment"
      python3 -m venv "$VENV" && source "$VENV/bin/activate" 
      success "virtual environment created"
    fi 
 } 

pip_upgrade() { 
    info "upgrading pip inside the virtual environment"
    "$VENV/bin/pip" install --upgrade pip 
    info "pip has been upgraded" 

 }

check_gitignore() {
    if [[ -f "${GITIGNORE}" ]];then 
    info "hurray! we found .gitignore"
    else
    info "lets create a gitignore file"
    cat <<EOF > "$GITIGNORE"
__pycache__/
.venv/
*.pyc
EOF
    success "gitignore successfully created"

 fi 
}

install_requirements() {
    if [[ -f "requirements.txt" ]];then
    info "installing dependencies"
    "$VENV/bin/pip" install -r requirements.txt \
    && success "dpendencies installed "
    else
    pip freeze > requirements.txt
    fi
}
main() {    
  check_venv
  pip_upgrade
  check_gitignore
  install_requirements
}

main

info "the setup is complete"