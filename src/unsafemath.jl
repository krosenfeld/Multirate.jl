
# Computes the dot product of a single column of a, specified by aColumnIdx, with the vector b.
# The number of elements used in the dot product determined by the size(A)[1].
# Note: bIdx is the last element of b used in the dot product.
function unsafedot( a::Matrix, aColIdx::Integer, b::Vector, bLastIdx::Integer )
    aLen     = size(a)[1]
    bBaseIdx = bLastIdx - aLen
    dotprod  = zero(eltype(b))
    for i in 1:aLen
        @inbounds dotprod += a[ i, aColIdx ] * b[ bBaseIdx + i ]
    end

    return dotprod
end

function unsafedot( a::Matrix, aColIdx::Integer, b::Vector, c::Vector, cLastIdx::Integer )
    aLen = size(a)[1]
    bLen = length(b)
    bLen == aLen-1  || error( "length(b) must equal to length(a)[1] - 1" )
    cLastIdx < aLen || error( "cLastIdx but be < length(a)")

    dotprod = zero( eltype(c) )
    for i in 1:aLen-cLastIdx
        @inbounds dotprod += a[ i, aColIdx ] * b[ i+cLastIdx-1 ]
    end
    for i in 1:cLastIdx
        @inbounds dotprod += a[ aLen-cLastIdx+i, aColIdx ] * c[ i ]
    end

    return dotprod
end

function unsafedot( a::Vector, b::Vector, bLastIdx::Integer )
    aLen     = length(a)
    bBaseIdx = bLastIdx - aLen
    dotprod  = zero(eltype(b))
    @simd for i in 1:aLen
        @inbounds dotprod += a[ i ] * b[ bBaseIdx + i ]
    end

    return dotprod
end

function unsafedot( a::Vector, b::Vector, c::Vector, cLastIdx::Integer )
    aLen    = length(a)
    dotprod = zero( eltype(b) )
    @simd for i in 1:aLen-cLastIdx
        @inbounds dotprod += a[ i ] * b[ i+cLastIdx-1 ]
    end
    @simd for i in 1:cLastIdx
        @inbounds dotprod += a[ aLen-cLastIdx+i ] * c[ i ]
    end

    return dotprod
end
