file_url = "https://github.com/dreal/dreal3/releases/download/v3.15.06.02/dReal-3.15.06.02-linux-shared-libs.tar.gz"
deps_dir = joinpath(joinpath(Pkg.dir("DReal"),"deps"))
prefix = joinpath(deps_dir,"usr")


println("Cleanup old build files")

try
  run(`rm  -r $(joinpath(deps_dir,"dReal*"))`)
catch end
try
  run(`rm -r $(joinpath(deps_dir,"usr"))`)
catch end

download(file_url,joinpath(deps_dir,"dReal-3.15.06.02-linux-shared-libs.tar.gz"))
run(`tar -xvf dReal-3.15.06.02-linux-shared-libs.tar.gz`)
run(`mv $(joinpath(deps_dir, "dReal-3.15.06.02-linux")) usr`)

# using BinDeps
# using Compat

# @BinDeps.setup
# import BinDeps: DirectoryRule

# libdreal = library_dependency("libdreal.so", runtime=true)

# drealdir = "dReal-3.15.06.02-linux"
# prefix=joinpath(BinDeps.depsdir(libdreal),"usr")
# @show prefix
# src_dir = joinpath(prefix,"src")
# bin_dir = joinpath(prefix,"bin")
# lib_dir = joinpath(prefix,"lib")

#   @show joinpath(lib_dir, "libdreal.so")
# fname = "dReal-3.15.06.02-linux-shared-libs.tar.gz"


# provides(SimpleBuild,
#     (@build_steps begin
#        ChangeDirectory(joinpath(Pkg.dir("DReal"), "deps"))
#        # CreateDirectory(prefix)
#        FileDownloader("https://github.com/dreal/dreal3/releases/download/v3.15.06.02/dReal-3.15.06.02-linux-shared-libs.tar.gz", joinpath(".", fname)) 
#        # FileUnpacker(joinpath(BinDeps.depsdir(libdreal),"dReal-3.15.06.02-linux-shared-libs.tar.gz"), prefix, "ok")
#        # DirectoryRule(lib_dir, @build_steps begin
#        #    FileUnpacker(fname, pwd(), "usr")
#        #  end)  
#        FileRule(joinpath(lib_dir, "libdreal.so"), @build_steps begin
#           `tar -xvf dReal-3.15.06.02-linux-shared-libs.tar.gz`
#           `mv $(joinpath(BinDeps.depsdir(libdreal), "dReal-3.15.06.02-linux")) usr`
#         end)
#     end), libdreal)

# @compat @BinDeps.install Dict(:libdreal => :libdreal)
