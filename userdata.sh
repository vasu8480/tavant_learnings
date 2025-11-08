# DevOps Commands Cheat Sheet

## Basic Linux Commands
Linux is the foundation of DevOps operations - it's like a Swiss Army knife for servers. These commands help you navigate systems, manage files, configure permissions, and automate tasks in terminal environments.

1. pwd - Print the current working directory.
2. ls - List files and directories.
3. cd - Change directory.
4. touch - Create an empty file.
5. mkdir - Create a new directory.
6. rm - Remove files or directories.
7. rmdir - Remove empty directories.
8. cp - Copy files or directories.
9. mv - Move or rename files and directories.
10. cat - Display the content of a file.
11. echo - Display a line of text.
12. clear - Clear the terminal screen.

## Intermediate Linux Commands
13. chmod - Change file permissions.
14. chown - Change file ownership.
15. find - Search for files and directories.
16. grep - Search for text in a file.
17. wc - Count lines, words, and characters in a file.
18. head - Display the first few lines of a file.
19. tail - Display the last few lines of a file.
20. sort - Sort the contents of a file.
21. uniq - Remove duplicate lines from a file.
22. diff - Compare two files line by line.
23. tar - Archive files into a tarball.
24. zip/unzip - Compress and extract ZIP files.
25. df - Display disk space usage.
26. du - Display directory size.
27. top - Monitor system processes in real time.
28. ps - Display active processes.
29. kill - Terminate a process by its PID.
30. ping - Check network connectivity.
31. wget - Download files from the internet.
32. curl - Transfer data from or to a server.
33. scp - Securely copy files between systems.
34. rsync - Synchronize files and directories.

## Advanced Linux Commands
35. awk - Text processing and pattern scanning.
36. sed - Stream editor for filtering and transforming text.
37. cut - Remove sections from each line of a file.
38. tr - Translate or delete characters.
39. xargs - Build and execute command lines from standard input.
40. ln - Create symbolic or hard links.
41. df -h - Display disk usage in human-readable format.
42. free - Display memory usage.
43. iostat - Display CPU and I/O statistics.
44. netstat - Network statistics (use ss as modern alternative).
45. ifconfig/ip - Configure network interfaces (use ip as modern alternative).
46. iptables - Configure firewall rules.
47. systemctl - Control the systemd system and service manager.
48. journalctl - View system logs.
49. crontab - Schedule recurring tasks.
50. at - Schedule tasks for a specific time.
51. uptime - Display system uptime.
52. whoami - Display the current user.
53. users - List all users currently logged in.
54. hostname - Display or set the system hostname.
55. env - Display environment variables.
56. export - Set environment variables.

## Basic Git Commands
Git is your code time machine. It tracks every change, enables team collaboration without conflicts, and lets you undo mistakes. These commands help manage source code versions like a professional developer.

1. git init - Initializes a new Git repository in the current directory. Example: git init
2. git clone - Copies a remote repository to the local machine. Example: git clone https://github.com/user/repo.git
3. git status - Displays the state of the working directory and staging area. Example: git status
4. git add - Adds changes to the staging area. Example: git add file.txt
5. git commit - Records changes to the repository. Example: git commit -m "Initial commit"
6. git config - Configures user settings, such as name and email. Example: git config --global user.name "Your Name"
7. git log - Shows the commit history. Example: git log
8. git show - Displays detailed information about a specific commit. Example: git show <commit-hash>
9. git diff - Shows changes between commits, the working directory, and the staging area. Example: git diff
10. git reset - Unstages changes or resets commits. Example: git reset HEAD file.txt

## Branching and Merging
11. git branch - Lists branches or creates a new branch. Example: git branch feature-branch
12. git checkout - Switches between branches or restores files. Example: git checkout feature-branch
13. git switch - Switches branches (modern alternative to git checkout). Example: git switch feature-branch
14. git merge - Combines changes from one branch into another. Example: git merge feature-branch
15. git rebase - Moves or combines commits from one branch onto another. Example: git rebase main
16. git cherry-pick - Applies specific commits from one branch to another. Example: git cherry-pick <commit-hash>

## Remote Repositories
17. git remote - Manages remote repository connections. Example: git remote add origin https://github.com/user/repo.git
18. git push - Sends changes to a remote repository. Example: git push origin main
19. git pull - Fetches and merges changes from a remote repository. Example: git pull origin main
20. git fetch - Downloads changes from a remote repository without merging. Example: git fetch origin
21. git remote -v - Lists the URLs of remote repositories. Example: git remote -v

## Stashing and Cleaning
22. git stash - Temporarily saves changes not yet committed. Example: git stash
23. git stash pop - Applies stashed changes and removes them from the stash list. Example: git stash pop
24. git stash list - Lists all stashes. Example: git stash list
25. git clean - Removes untracked files from the working directory. Example: git clean -f

## Tagging
26. git tag - Creates a tag for a specific commit. Example: git tag -a v1.0 -m "Version 1.0"
27. git tag -d - Deletes a tag. Example: git tag -d v1.0
28. git push --tags - Pushes tags to a remote repository. Example: git push origin --tags

## Advanced Commands
29. git bisect - Finds the commit that introduced a bug. Example: git bisect start
30. git blame - Shows which commit and author modified each line of a file. Example: git blame file.txt
31. git reflog - Shows a log of changes to the tip of branches. Example: git reflog
32. git submodule - Manages external repositories as submodules. Example: git submodule add https://github.com/user/repo.git
33. git archive - Creates an archive of the repository files. Example: git archive --format=zip HEAD > archive.zip
34. git gc - Cleans up unnecessary files and optimizes the repository. Example: git gc

## GitHub-Specific Commands
35. gh auth login - Logs into GitHub via the command line. Example: gh auth login
36. gh repo clone - Clones a GitHub repository. Example: gh repo clone user/repo
37. gh issue list - Lists issues in a GitHub repository. Example: gh issue list
38. gh pr create - Creates a pull request on GitHub. Example: gh pr create --title "New Feature" --body "Description of the feature"
39. gh repo create - Creates a new GitHub repository. Example: gh repo create my-repo

## Basic Docker Commands
Docker packages applications into portable containers - like shipping containers for software. These commands help build, ship, and run applications consistently across any environment.

1. docker --version - Displays the installed Docker version. Example: docker --version
2. docker info - Shows system-wide information about Docker, such as the number of containers and images. Example: docker info
3. docker pull - Downloads an image from a Docker registry (default: Docker Hub). Example: docker pull ubuntu:latest
4. docker images - Lists all downloaded images. Example: docker images
5. docker run - Creates and starts a new container from an image. Example: docker run -it ubuntu bash
6. docker ps - Lists running containers. Example: docker ps
7. docker ps -a - Lists all containers, including stopped ones. Example: docker ps -a
8. docker stop - Stops a running container. Example: docker stop container_name
9. docker start - Starts a stopped container. Example: docker start container_name
10. docker rm - Removes a container. Example: docker rm container_name
11. docker rmi - Removes an image. Example: docker rmi image_name
12. docker exec - Runs a command inside a running container. Example: docker exec -it container_name bash

## Intermediate Docker Commands
13. docker build - Builds an image from a Dockerfile. Example: docker build -t my_image .
14. docker commit - Creates a new image from a container’s changes. Example: docker commit container_name my_image:tag
15. docker logs - Fetches logs from a container. Example: docker logs container_name
16. docker inspect - Returns detailed information about an object (container or image). Example: docker inspect container_name
17. docker stats - Displays live resource usage statistics of running containers. Example: docker stats
18. docker cp - Copies files between a container and the host. Example: docker cp container_name:/path/in/container /path/on/host
19. docker rename - Renames a container. Example: docker rename old_name new_name
20. docker network ls - Lists all Docker networks. Example: docker network ls
21. docker network create - Creates a new Docker network. Example: docker network create my_network
22. docker network inspect - Shows details about a Docker network. Example: docker network inspect my_network
23. docker network connect - Connects a container to a network. Example: docker network connect my_network container_name
24. docker volume ls - Lists all Docker volumes. Example: docker volume ls
25. docker volume create - Creates a new Docker volume. Example: docker volume create my_volume
26. docker volume inspect - Provides details about a volume. Example: docker volume inspect my_volume
27. docker volume rm - Removes a Docker volume. Example: docker volume rm my_volume

## Advanced Docker Commands
28. docker-compose up - Starts services defined in a docker-compose.yml file. Example: docker-compose up
29. docker-compose down - Stops and removes services defined in a docker-compose.yml file. Example: docker-compose down
30. docker-compose logs - Displays logs for services managed by Docker Compose. Example: docker-compose logs
31. docker-compose exec - Runs a command in a service’s container. Example: docker-compose exec service_name bash
32. docker save - Exports an image to a tar file. Example: docker save -o my_image.tar my_image:tag
33. docker load - Imports an image from a tar file. Example: docker load < my_image.tar
34. docker export - Exports a container’s filesystem as a tar file. Example: docker export container_name > container.tar
35. docker import - Creates an image from an exported container. Example: docker import container.tar my_new_image
36. docker system df - Displays disk usage by Docker objects. Example: docker system df
37. docker system prune - Cleans up unused Docker resources (images, containers, volumes, networks). Example: docker system prune
38. docker tag - Assigns a new tag to an image. Example: docker tag old_image_name new_image_name
39. docker push - Uploads an image to a Docker registry. Example: docker push my_image:tag
40. docker login - Logs into a Docker registry. Example: docker login
41. docker logout - Logs out of a Docker registry. Example: docker logout
42. docker swarm init - Initializes a Docker Swarm mode cluster. Example: docker swarm init
43. docker service create - Creates a new service in Swarm mode. Example: docker service create --name my_service nginx
44. docker stack deploy - Deploys a stack using a Compose file in Swarm mode. Example: docker stack deploy -c docker-compose.yml my_stack
45. docker stack rm - Removes a stack in Swarm mode. Example: docker stack rm my_stack
46. docker checkpoint create - Creates a checkpoint for a container. Example: docker checkpoint create container_name checkpoint_name
47. docker checkpoint ls - Lists checkpoints for a container. Example: docker checkpoint ls container_name
48. docker checkpoint rm - Removes a checkpoint. Example: docker checkpoint rm container_name checkpoint_name