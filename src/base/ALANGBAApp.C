#include "ALANGBAApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
ALANGBAApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

ALANGBAApp::ALANGBAApp(InputParameters parameters) : MooseApp(parameters)
{
  ALANGBAApp::registerAll(_factory, _action_factory, _syntax);
}

ALANGBAApp::~ALANGBAApp() {}

void
ALANGBAApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAllObjects<ALANGBAApp>(f, af, s);
  Registry::registerObjectsTo(f, {"ALANGBAApp"});
  Registry::registerActionsTo(af, {"ALANGBAApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
ALANGBAApp::registerApps()
{
  registerApp(ALANGBAApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
ALANGBAApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ALANGBAApp::registerAll(f, af, s);
}
extern "C" void
ALANGBAApp__registerApps()
{
  ALANGBAApp::registerApps();
}
