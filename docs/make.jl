using Documenter, DemoCards


# 1. generate a DemoCard theme
templates, theme = cardtheme()

# 2. generate demo files
quickstart, postprocess_cb = makedemos("quickstart", templates)

# 3. normal Documenter usage
format = Documenter.HTML(edit_link = "master",
                         prettyurls = get(ENV, "CI", nothing) == "true",
                         assets = [theme])

makedocs(format = format,
         pages = [
            "Home" => "index.md",
            "QuickStart" => quickstart,
            "Concepts" => "concepts.md",
            "Package References" => "references.md"
         ],
         sitename = "DemoCards.jl")

# 4. postprocess after makedocs
postprocess_cb()

# 5. deployment
if !haskey(ENV, "CI_TEST")
   # test stage also build the docs but not deploy it
   deploydocs(repo = "github.com/johnnychen94/DemoCards.jl.git")
end
