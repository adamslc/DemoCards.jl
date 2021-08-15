module DemoCards

import Base: basename
using Dates
using Mustache
using Literate
using ImageCore
using FileIO, JSON, YAML
using Suppressor # suppress log generated by 3rd party tools, e.g., Literate
import HTTP
using Documenter

const JULIA_COMPAT = let regex=r"julia\s*=\s*\"([\d\.]*)\""
    lines = filter(readlines(normpath(@__DIR__, "..", "Project.toml"))) do line
        occursin(regex, line)
    end
    VersionNumber(match(regex, lines[1]).captures[1])
end
const config_filename = "config.json"
const template_filename = "index.md"
# directly copy these folders without processing
const ignored_dirnames = ["assets"]

function verbose_mode()
    if haskey(ENV, "DOCUMENTER_DEBUG")
        rst = ENV["DOCUMENTER_DEBUG"]
        return lowercase(strip(rst)) == "true"
    else
        return false
    end
end

include("compat.jl")

include("types/card.jl")
include("types/section.jl")
include("types/page.jl")

include("utils.jl")
include("show.jl")

include("Themes/Themes.jl")
using .CardThemes

include("generate.jl")
include("preview.jl")

export makedemos, cardtheme, preview_demos


"""

This package breaks the rendering of the whole demo page into three types:

* `DemoPage` contains serveral `DemoSection`s;
* `DemoSection` contains either serveral `DemoSection`s or serveral `DemoCard`s;
* `DemoCard` consists of cover image, title and other necessary information.
"""
DemoCards

end # module
