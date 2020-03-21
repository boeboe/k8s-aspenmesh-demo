#!/bin/bash
# Ask the user for AspenMesh.io login details

read -p 'AspenMesh Username: ' uservar
read -sp 'AspenMesh Password: ' passvar
echo
echo Thank you ${uservar} we now have your login details
export ASPEN_MESH_USERNAME=${uservar}
export ASPEN_MESH_PASSWORD=${passvar}
