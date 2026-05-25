module openturns

using CxxWrap
@readmodule(() -> "openturns_julia")
@wraptypes
CxxWrap.CxxWrapCore.argument_overloads(::Type{Description}) = [Vector{String}]
CxxWrap.CxxWrapCore.argument_overloads(::Type{Point}) = [Vector{Float64}]

function Base.convert(::Type{Point}, v::Vector{Float64})
    coll = Point(length(v), 0.0)
    for (i, x) in enumerate(v)
        coll[i] = x
    end
    coll
end

function Base.convert(::Type{Description}, v::Vector{String})
    coll = Description(length(v), "")
    for (i, x) in enumerate(v)
        coll[i] = x
    end
    coll
end

@wrapfunctions

function __init__()
  @initcxx
  @eval Base.getindex(p::Point, i::Integer) = getindex(p, Int(i))
  @eval Base.getindex(d::Description, i::Integer) = getindex(d, Int(i))
  @eval Base.getindex(s::Sample, i::Integer) = getindex(s, Int(i))
  @eval Point(v::Vector{Float64}) = begin
      coll = Point(length(v), 0.0)
      for (i, x) in enumerate(v)
          coll[i] = x
      end
      coll
  end
  @eval Description(v::Vector{String}) = begin
      coll = Description(length(v), "")
      for (i, x) in enumerate(v)
          coll[i] = x
      end
      coll
  end
end

for _type in [Point, Description, Sample, Arcsine, Beta, Normal, SymbolicFunction, JuliaFunction]
    Base.show(io::IO, x::_type) = print(io, repr(x))
end

end
