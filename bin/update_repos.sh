# Update all repos in the same dir


# Let the person running the script know what's going on.
echo "\n\033[1mPulling in latest changes for all repositories...\033[0m\n"

cd ..
# Directory should be parent folder of all div projs
CUR_DIR=$(pwd)

# Find all git repositories and update it to the master latest revision
for i in $(find . -name ".github" -maxdepth 2 -type d); do
    echo "";
    echo "\033[33m"+$i+"\033[0m";

    # go to .git parent directory to call the pull command
    cd "$i";
    cd ..;

    git pull origin master;

    cd $CUR_DIR
done

echo "\n\033[32mComplete!\033[0m\n"
