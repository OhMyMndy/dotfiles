#!/usr/bin/env bash


checked_hashes="/var/www/html/.cregoratool-ci_checked_hashes"
errors="/var/www/html/.cregoratool-ci_errors"

cd /var/www/html/cregoratool_ci;

git fetch --all


commits=$(git log --pretty=format:"%H" --all --since=2.days.ago | sed '/^\s*$/d') # "%H -- %ai -- %an -- %D"


commits="development"
while read -r commit; do
    git clean -fd
    git reset --hard
    git checkout "$commit"

    grep -q "$commit" "$checked_hashes"
    if [ $? -ne 0 ]; then
        echo "Processing $commit"
        echo "===== Commit $commit =====" >> "$errors"

        echo "===== Commit $commit  import_database_dumps =====" >> "$errors"
        docker exec -u www-data webdev_php56_1 bash -c "cd cregoratool_ci; printf \"\n\n\n\n\n\" | ./common/tools/import_database_dumps.sh nmb nmb_ci"  2>&1 | tee -a "$errors"
        if [ $? -ne 0 ]; then
            exit 1
            continue
        fi


        echo "===== Commit $commit  PhpStan =====" >> "$errors"
        ./bin/phpstan --memory-limit 1G . 2>&1 | tee -a "$errors"
        if [ $? -ne 0 ]; then
            exit 3
            continue
        fi

        echo "===== Commit $commit  Update project =====" >> "$errors"
        docker exec -u www-data webdev_php56_1 bash -c "bash /var/www/html/cregoratool_ci/common/tools/update_project.sh -p nmb"  2>&1 | tee -a "$errors"
        if [ $? -ne 0 ]; then
            exit 2
            continue
        fi

        echo "===== Commit $commit  Php Unit =====" >> "$errors"
        ./bin/phpunit --configuration "phpunit.xml" 2>&1 | tee -a "$errors"
        if [ $? -ne 0 ]; then
            exit 4
            continue
        fi

        echo "$commit" >> "$checked_hashes"
    else
        echo "Skipping $commit"
    fi
done <<< "$commits"

