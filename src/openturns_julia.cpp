
#include "openturns_julia.hpp"

#include "JuliaFunction.hxx"
#include <jlcxx/functions.hpp>

#include <openturns/OT.hxx>
using namespace OT;

template <typename T>
jlcxx::TypeWrapper<T> define_object(jlcxx::TypeWrapper<T> object_type)
{
  return object_type
    .method("repr", [] (const T & p) { return p.__repr__();})
    .method("getName", &T::getName);
}

template <typename T>
jlcxx::TypeWrapper<T> define_collection(jlcxx::TypeWrapper<T> collection_type)
{
  define_object(collection_type);
  return collection_type
    .method("getSize", &T::getSize)
    .method("clear", &T::clear)
    .method("resize", &T::resize)
    .method("isEmpty", &T::isEmpty);
}

template <typename T>
jlcxx::TypeWrapper<T> define_distribution(jlcxx::TypeWrapper<T> distribution_type)
{
  define_object(distribution_type);
  return distribution_type
    .method("getDimension", &T::getDimension)
    .method("getRealization", &T::getRealization)
    .method("getSample", [] (const T& n, const int_t size) { return n.getSample(size); } )
    .method("computePDF", [] (const T& n, const Point & x) { return n.computePDF(x); } )
    .method("computeCDF", [] (const T& n, const Point & x) { return n.computeCDF(x); } )
    .method("computeQuantile", [] (const T& n, const double p) { return n.computeQuantile(p); } )
    .method("getMean", &T::getMean)
    .method("getSkewness", &T::getSkewness)
    .method("getKurtosis", &T::getKurtosis);
}

template <typename T>
jlcxx::TypeWrapper<T> define_function(jlcxx::TypeWrapper<T> function_type)
{
  define_object(function_type);
  return function_type
    .method("getInputDimension", &T::getInputDimension)
    .method("getOutputDimension", &T::getOutputDimension)
    .method("getCallsNumber", &T::getCallsNumber)
    .method("call", [](const T &function, jlcxx::ArrayRef<double> in)
    {
      Point inP(in.size());
      std::copy(in.begin(), in.end(), inP.begin());
      Point outP(function(inP));
      return outP;
    });
}

JLCXX_MODULE define_julia_module(jlcxx::Module& mod)
{
  define_collection(mod.add_type<Point>("Point"))
    .constructor<const int_t, const double>()
    .method("norm", &Point::norm)
    .method("getDimension", &Point::getDimension);
  mod.set_override_module(jl_base_module);
  mod.method("getindex", [] (const Point& n, const int_t i) { return n[i]; });
  mod.method("setindex!", [] (Point& n, const double x, const int_t i) { n[i] = x; });
  mod.unset_override_module();

  define_object(mod.add_type<Sample>("Sample"))
    .constructor<const int_t, const int_t>()
    .method("getSize", &Sample::getSize)
    .method("getDimension", &Sample::getDimension)
    .method("computeMean", &Sample::computeMean);
  mod.set_override_module(jl_base_module);
  mod.method("getindex", [] (const Sample& n, const int_t i) { return Point(n[i]); });
  mod.method("setindex!", [] (Sample& n, const Point & x, const int_t i) { n[i] = x; });
  mod.unset_override_module();

  define_distribution(mod.add_type<Arcsine>("Arcsine"))
    .constructor<const double, const double>();
  define_distribution(mod.add_type<Beta>("Beta"))
    .constructor<const double, const double, const double, const double>();
  define_distribution(mod.add_type<Normal>("Normal"))
    .constructor<const int_t>()
    .constructor<const double, const double>();

  define_function(mod.add_type<SymbolicFunction>("SymbolicFunction"))
    .constructor<const String &, const String &>();
  define_function(mod.add_type<OTJULIA::JuliaFunction>("JuliaFunction"))
    .constructor<const int_t, const int_t, jl_function_t*>();
}

