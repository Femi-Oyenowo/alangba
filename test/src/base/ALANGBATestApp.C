//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "ALANGBATestApp.h"
#include "ALANGBAApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
ALANGBATestApp::validParams()
{
  InputParameters params = ALANGBAApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

ALANGBATestApp::ALANGBATestApp(InputParameters parameters) : MooseApp(parameters)
{
  ALANGBATestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

ALANGBATestApp::~ALANGBATestApp() {}

void
ALANGBATestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  ALANGBAApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"ALANGBATestApp"});
    Registry::registerActionsTo(af, {"ALANGBATestApp"});
  }
}

void
ALANGBATestApp::registerApps()
{
  registerApp(ALANGBAApp);
  registerApp(ALANGBATestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
ALANGBATestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ALANGBATestApp::registerAll(f, af, s);
}
extern "C" void
ALANGBATestApp__registerApps()
{
  ALANGBATestApp::registerApps();
}
