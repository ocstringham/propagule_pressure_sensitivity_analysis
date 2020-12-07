# ---------------------------------------------------------------------------- #
# script to define functions that calculate PE and dpe/dps, dpe/dni, dpe/dq ---#
# ---------------------------------------------------------------------------- #

# PE (establishment probability)
pe = function(ps, ni, q, c){ ( 1 - ((q^ps^c)^ni) ) }


# dpe/dps
dpe_dps = function(ps, ni, q, c){ ((q^(ps-1)^c)^ni) - ((q^(ps)^c)^ni) }


# dpe/dni
dpe_dni = function(ps, ni, q, c){ ((q^ps^c)^(ni-1)) - ((q^ps^c)^(ni)) }


# dpe/dq
dpe_dq = function(ps, ni, q, c, phi){ (((q)^ps^c)^(ni)) - (((q+phi)^ps^c)^(ni))}



