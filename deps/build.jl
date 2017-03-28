using BinDeps
using Compat

@BinDeps.setup

@static if is_apple()
  ostype = "apple"
  elseif is_windows()
    ostype = "windows"
  elseif is_linux()
    ostype = "linux"
  else
    error("No wkhtmltox library available for this OS")
  end

ostype *= Int==Int64 ? "64" : "32"

# exephantomjs = library_dependency("exephantomjs",
#                                   aliases=["phantomjs.exe",
#                                            "phantomjs"])

ver = "2.1.1"

archivemap = Dict(
 "apple32"   => "-macosx.zip",
 "windows32" => "-windows.zip",
 "linux32"   => "-linux-i686.tar.bz2",
 "apple64"   => "-macosx.zip",
 "windows64" => "-windows.zip",
 "linux64"   => "-linux-x86_64.tar.bz2",
 )

url = "https://cnpmjs.org/downloads/phantomjs-" *
      ver *
      archivemap[ostype]

downloadname = basename(url)

exemap = Dict(
 "apple32"   => "bin/phantomjs",
 "windows32" => "bin/phantomjs.exe",
 "linux32"   => "bin/phantomjs",
 "apple64"   => "bin/phantomjs",
 "windows64" => "bin/phantomjs.exe",
 "linux64"   => "bin/phantomjs",
 )

exepath = joinpath(splitext(downloadname)[1],exemap[ostype])
exefile = basename(exepath)
dirname(exepath)

# provides(Binaries, URI(url), exephantomjs)

Pkg.dir("PhantomJS")

# libdir = BinDeps.libdir(exephantomjs)
destdir = Pkg.dir("PhantomJS", "deps/usr/bin") # BinDeps.bindir(exephantomjs)
unzipdir = Pkg.dir("PhantomJS", "deps/src") # BinDeps.srcdir(exephantomjs)
downloadsdir = Pkg.dir("PhantomJS", "deps/downloads") # BinDeps.downloadsdir(exephantomjs)


run( @build_steps FileRule( [joinpath(destdir, exefile)],
      @build_steps begin
        CreateDirectory(downloadsdir, true)
        FileDownloader(url, joinpath(downloadsdir, downloadname))
        CreateDirectory(unzipdir, true)
        FileUnpacker(joinpath(downloadsdir, downloadname), unzipdir, exepath)
        CreateDirectory(destdir, true)
        cp(joinpath(unzipdir,exepath), joinpath(destdir,exefile))
      end ) )



#
#
# @build_steps begin
#     GetSources(libpng)
#     CreateDirectory(pngbuilddir)
#     @build_steps begin
#         ChangeDirectory(pngbuilddir)
#         FileRule(joinpath(prefix,"lib","libpng15.dll"),@build_steps begin
#             `cmake -DCMAKE_INSTALL_PREFIX="$prefix" -G"MSYS Makefiles" $pngsrcdir`
#             `make`
#             `cp libpng*.dll $prefix/lib`
#             `cp libpng*.a $prefix/lib`
#             `cp libpng*.pc $prefix/lib/pkgconfig`
#             `cp pnglibconf.h $prefix/include`
#             `cp $pngsrcdir/png.h $prefix/include`
#             `cp $pngsrcdir/pngconf.h $prefix/include`
#         end)
#     end
# end
#
#
#
# type FileCopyRule <: BinDeps.BuildStep
#     src::AbstractString
#     dest::AbstractString
# end
# Base.run(fc::FileCopyRule) = isfile(fc.dest) || cp(fc.src, fc.dest)
#
#
# provides(BuildProcess,
# 	(@build_steps begin
#     CreateDirectory(downloadsdir, true)
# 		FileDownloader(url, joinpath(downloadsdir, downloadname))
# 		CreateDirectory(srcdir, true)
#     FileUnpacker(joinpath(downloadsdir, downloadname), srcdir, exepath)
# 		CreateDirectory(libdir, true)
#     FileCopyRule(joinpath(srcdir,exepath), joinpath(libdir,exefile))
# 	end), exephantomjs)
#
# push!(BinDeps.defaults, BuildProcess)

# @BinDeps.install Dict(:exephantomjs => :exephantomjs)
