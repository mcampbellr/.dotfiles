local status, docker = pcall(require, "docker")

if not status then
    return
end

docker.setup {}
