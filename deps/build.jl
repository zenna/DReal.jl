version = "3.15.07.02"
os_string = @osx? "darwin" : "linux"
file_url = "https://github.com/dreal/dreal3/releases/download/v$version/dReal-$version-$os_string-shared-libs.tar.gz"
deps_dir = joinpath(joinpath(Pkg.dir("DReal"),"deps"))
prefix = joinpath(deps_dir,"usr")


println("Cleanup old build files")

try
  run(`rm  -r $(joinpath(deps_dir,"dReal*"))`)
catch end
try
  run(`rm -r $(joinpath(deps_dir,"usr"))`)
catch end

download(file_url,joinpath(deps_dir,"dReal-$version-$os_string-shared-libs.tar.gz"))
@osx? begin
	run(pipe(`gunzip -c dReal-$version-$os_string-shared-libs.tar.gz`, `tar -xv`))
end : begin
	run(`tar -xvf dReal-$version-$os_string-shared-libs.tar.gz`)
end
run(`mv $(joinpath(deps_dir, "dReal-$version-$os_string-shared-libs")) usr`)
