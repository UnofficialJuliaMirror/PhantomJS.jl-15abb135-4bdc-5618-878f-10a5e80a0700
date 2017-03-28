module PhantomJS

export renderhtml

const phantomjspath = joinpath(dirname(@__FILE__),
                               "../deps/usr/bin/phantomjs")

# renders html to provided IO
function renderhtml(source::IO, format::String="png")
  local result

  mktempdir() do tdir

    # source = IOBuffer(read("c:/temp/vegalite.html"))
    # source = open("c:/temp/vegalite.html")
    # tdir = "c:/temp"

    # htmlpath, htmlio = mktemp(tdir)
    htmlpath = joinpath(tdir, randstring() * ".html")
    open(io -> write(io, read(source)), htmlpath, "w")
    htmlpath = replace(htmlpath, "\\", "/")
    println(htmlpath)

    destpath = joinpath(tdir, randstring() * ".png")
    destpath = replace(destpath, "\\", "/")
    println(destpath)

    jsscript = """
    "use strict";
    var page = require('webpage').create(),
        system = require('system'),
        address, output, size, pageWidth, pageHeight;

    address = 'file:///$htmlpath';
    output = '$destpath';

    page.viewportSize = { width: 600, height: 400 };
    page.paperSize = { width: 600, height: 400, margin: '0px' };

    page.open(address, function (status) {
        if (status !== 'success') {
            console.log('Unable to load the address : ' + address);
            phantom.exit(1);
        } else {
            window.setTimeout(function () {
                page.render(output);
                console.log('output saved to : ' + output);
                phantom.exit();
            }, 200);
        }
    });
    """

    jspath = joinpath(tdir, randstring() * ".js")
    open(io -> write(io, jsscript), jspath, "w")

    run(`$phantomjspath $jspath`)
    result = read(destpath)
  end

  result
end

end # module
