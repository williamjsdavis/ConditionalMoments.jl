using ConditionalMoments
using Documenter

DocMeta.setdocmeta!(ConditionalMoments, :DocTestSetup, :(using ConditionalMoments); recursive=true)

makedocs(;
    modules=[ConditionalMoments],
    authors="William Davis",
    repo="https://github.com/williamjsdavis/ConditionalMoments.jl/blob/{commit}{path}#{line}",
    sitename="ConditionalMoments.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://williamjsdavis.github.io/ConditionalMoments.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/williamjsdavis/ConditionalMoments.jl",
)
