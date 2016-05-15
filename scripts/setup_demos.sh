# Include this in bash environment with 'source $0'

echorun() {
    echo -n "\$ "    
    read -n1
    arg="$1"
    delay=0.02
    for (( i=0; i < ${#arg}; i+=1 )) ; do
	echo -n "${arg:$i:1}"
	r=$RANDOM
	delay=`echo "$(($r % 8)) * 0.005" | bc -l`
	sleep $delay
    done
    read i  # hit return
    eval "$1"
    echo
}

slowecho() {
    echo -n "\$ "
    read -n1
    arg="$1"
    delay=0.02
    for (( i=0; i < ${#arg}; i+=1 )) ; do
	echo -n "${arg:$i:1}"
	sleep 0.005
    done
    read i
}

feedback() {
    arg="$1"
    for (( i=0; i < ${#arg}; i+=1 )) ; do
	echo -n "${arg:$i:1}"
	sleep 0.005
    done
    echo
    echo
}

run_what_I_want() {
    clear
    feedback 'Ready.'
    slowecho 'cd my_project_with_database'
    slowecho 'git checkout my_branch'
    feedback 'done.'
    slowecho 'make db'
    feedback 'done.'
    slowecho 'make test'
    feedback '..........................'
    feedback 'All tests pass.'
    slowecho 'git merge work_from_alice'
    feedback 'done.'
    slowecho 'make db'
    feedback 'updated.'
    slowecho 'make test'
    feedback '........................................'
    feedback 'All tests pass.'
    slowecho 'clear'
    clear
    slowecho '<hack hack hack hack>'
    echo
    slowecho 'make db'
    feedback 'I can''t do that for you, Dave.'
    sleep 1
    feedback 'Your database change is not compatible with the work from Alice.'
    slowecho 'clear'
    clear
    slowecho '<hack hack hack>'
    slowecho 'make db'
    feedback 'done.'
    slowecho 'make test'
    feedback '........................................'
    feedback 'All tests pass.'
    echo
    echo '--- END ---'
    echo
}

run_demo_1_initial_setup() {
    git checkout demo_prod
    git branch -D my_branch
    clear
    feedback 'Ready.'
    echorun 'git checkout demo_prod -b my_branch'
    echorun 'python tools/migrate.py'
    echorun 'python tools/migrate.py -nsu'
    echorun 'make seed; make flask'
}

run_demo_2_update() {
    clear
    feedback 'Ready.'
    echorun 'git merge demo_alice'
    echorun 'python tools/migrate.py -u'
    echorun 'make seed; make flask'
}

run_demo_3_backwards_compat() {
    clear
    feedback 'Ready.'
    echorun 'git checkout demo_dev'
    echorun './test/run_compat_test.sh demo_dev demo_prod pause'
    echo
    echo '--- END ---'
    echo
}

run_demo_4_forwards_compat() {
    git checkout my_branch
    git reset --hard demo_3_fwd_compat
    clear
    feedback 'Ready.'
    echorun 'tools/setup_forward_compat_work_env.sh pending_change pause'
    echorun 'clear'
    echorun 'git status'
    echorun 'git merge demo_dev'
    echorun 'make db_all; make test'
    echorun 'clear'
    echorun 'tools/setup_forward_compat_work_env.sh pending_change pause'    
    echo
    echo '--- END ---'
    echo
}

function run_finale() {
    clear
    feedback 'Ready.'
    echorun 'git checkout demo_dev'
    echorun 'make db_all; make test'
    echorun 'clear'
    echo '# BACKWARDS-COMPAT'
    echorun './test/run_compat_test.sh demo_dev demo_prod'
    echorun 'clear'
    echo '# FORWARDS-COMPAT'
    echorun './tools/setup_forward_compat_work_env.sh pending_change'
    echorun 'clear'
    echorun '# Or run it as a single nightly job:'
    git checkout demo_dev
    make db_all
    make test
    ./test/run_compat_test.sh demo_dev demo_prod
    ./tools/setup_forward_compat_work_env.sh pending_change
    echo
    echo '--- END ---'
    echo
}

alias the_dream='run_what_I_want'
alias an_impossible_dream='run_what_I_want'
alias demo_1='run_demo_1_initial_setup'
alias demo_2='run_demo_2_update'
alias demo_3='run_demo_3_backwards_compat'
alias demo_4='run_demo_4_forwards_compat'
alias finale='run_finale'
