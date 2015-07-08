using DReal

a = [Var(Float64, -5.0, 5.0) for i = 1:14]
p = ForallVar(Float64, -2.0, 2.0)
r = ForallVar(Float64, -2.0, 2.0)
pest = ForallVar(Float64, -2.0, 2.0)
i = ForallVar(Float64, -2.0, 2.0)

c1 = 0.41328
c2 = 200.0
c3 = -0.366
c4 = 0.08979
c5 = -0.0337
c6 = 0.0001
c7 = 2.821
c8 = -0.05231
c9 = -0.05231
c9 = 0.10299
c10 = -0.00063
c11 = 1.0
c12 = 14.7
c13 = 0.9
c14 = 0.4
c15 = 0.4
c16 = 1.0
u = 23.0829

# Derivatives
pdot = c1 * ( 2*u*sqrt(p/c11 - (p/c11)^2) - (c3 + c4*c2*p + c5 * c2 *
  p^2 + c6*c2^2 * p))

rdot = 4 * ((c3 + c4*c2*p + c5*c2*p^2 + c6*c2^2*p)/
                (c13*(c3+c4*c2*pest^2 + c5*c2*pest^2 + c6*c2^2*pest)*
                     (1+i+c14*(r-c16)))-r)

pestdot = c1 * ((2*u*sqrt(p/c11 -
  (p/c11)^2))-c13*(c3+c4*c2*pest+c5*c2*pest^2+c6*c2^2*pest))

idot = c15*(r-c16)

V = (a[1]*p^2 + a[2]*r^2 + a[3]*pest^2 + a[4]*i^2 + a[5]*p*r +
a[6]*r*pest + a[7] * r*i + a[8] * pest*i + a[9]*p*i + a[10]*p +
a[11]*r + a[12]*pest + a[13]*i + a[14])^2

common = (a[14] + a[13]*i + a[4]*i^2 + a[10]*p + 
   a[9]*i*p + a[1]*p^2 + a[12]*pest + a[8]*i*pest + a[3]*pest^2 + a[11]*r + 
   a[7]*i*r + a[5]*p*r + a[6]*pest*r + a[2]*r^2)

# Partial Derivatives of V
dvbydp = 2 * (a[10] + a[9]*i + 2*a[1]*p + a[5]*r)
dvbydpest = 2*(a[12] + a[8]*i + 2*a[3]*pest + a[6]*r)
dvbydi = 2*(a[13] + 2*a[4]*i + a[9]*p + a[8]*pest + a[7]*r)
dvbydr = 2*(a[11] + a[7]*i + a[5]*p + a[6]*pest + 2*a[2]*r)

add!(common*(dvbydp * pdot + dvbydr * rdot + dvbydpest * pestdot + dvbydi * idot) < 0)
add!(V >= 0.0)
add!(p^2>0.001)
add!(r^2>0.001)
add!(pest^2 > 0.001)
add!(i^2 >0.001)
