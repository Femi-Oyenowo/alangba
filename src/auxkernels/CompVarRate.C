/*
AuxKernel of Passing Variable Time Derivative 
*/

#include "CompVarRate.h"

registerMooseObject("ALANGBAApp", CompVarRate);

InputParameters
CompVarRate::validParams()
{
  InputParameters params = AuxKernel::validParams();

  params.addRequiredCoupledVar("coupled","Nonlinear Variable that needed to be taken time derivative of");

  return params;
}

CompVarRate::CompVarRate(const InputParameters & parameters)
  : AuxKernel(parameters),
  
  //Compute the time derivative of the given variable using "coupledDot"
  _coupled_val(coupledValue("coupled")),
  _coupled_val_old(coupledValueOld("coupled"))

{
}

Real
CompVarRate::computeValue()
{
  return (_coupled_val[_qp] - _coupled_val_old[_qp]) / _dt;
}