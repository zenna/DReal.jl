version = "3.15.07.02"
os_string = @osx? "darwin" : "linux"
extension = @osx? "zip" : "tar.gz"

file_name = "dReal-$version-$os_string-shared-libs.$extension"
file_url = "https://github.com/dreal/dreal3/releases/download/v$version/$file_name"
deps_dir = joinpath(joinpath(Pkg.dir("DReal"),"deps"))
prefix = joinpath(deps_dir,"usr")


println("Cleanup old build files")

try
  run(`rm  -r $(joinpath(deps_dir,"dReal*"))`)
catch end
try
  run(`rm -r $(joinpath(deps_dir,"usr"))`)
catch end

download(file_url,joinpath(deps_dir,file_name))
@osx? begin
  run(`unzip $file_name`)
end : begin
  run(`tar -xvf $file_name`)
end
run(`mv $(joinpath(deps_dir, "dReal-$version-$os_string-shared-libs")) usr`)
