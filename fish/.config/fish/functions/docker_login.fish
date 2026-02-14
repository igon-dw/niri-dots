function docker_login
    # If no argument, select with fzf; otherwise use the given argument
    set -l container_name $argv[1]

    if test -z "$container_name"
        # Check if fzf is installed
        if not type -q fzf
            echo "Error: fzf is required but not installed."
            return 1
        end

        # List all containers including stopped ones, and select
        set container_name (docker ps -a --format '{{.Names}}' | fzf)
    end

    # Exit if cancelled or empty
    if test -z "$container_name"
        echo "No container selected."
        return 1
    end

    # Check container existence
    if not docker ps -a --filter "name=^$container_name\$" --quiet >/dev/null
        echo "Container '$container_name' not found."
        return 1
    end

    # Start container (no error if already running)
    echo "Starting container: $container_name..."
    docker start "$container_name" >/dev/null

    # [IMPORTANT] Use exec instead of attach
    # attach connects to PID 1, which can make it inoperable if not a shell
    echo "Entering container shell..."

    # Try fish shell (fallback to bash, then sh)
    if docker exec "$container_name" test -x /bin/fish >/dev/null 2>&1
        docker exec -i -t "$container_name" /bin/fish -l
    else if docker exec "$container_name" test -x /bin/bash >/dev/null 2>&1
        docker exec -i -t "$container_name" /bin/bash -l
    else
        docker exec -i -t "$container_name" /bin/sh -l
    end

    # Stop container after exiting shell
    echo "Stopping container: $container_name..."
    docker stop "$container_name" >/dev/null
end
