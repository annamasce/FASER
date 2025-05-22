#include <iostream>
#include <vector>

#include <rave/VertexFactory.h>

int main() {
  rave::VertexFactory factory (MyMagneticField(), MyPropagator(), method, verbosity);
  std::vector<rave::Vertex> vertices = factory.create(tracks);

  return 0;
}