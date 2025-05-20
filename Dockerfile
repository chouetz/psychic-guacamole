# Adapted from https://github.com/pulumi/pulumi-docker-containers/blob/main/docker/pulumi/Dockerfile
# to minimize image size

FROM public.ecr.aws/docker/library/python:3.12-slim-bullseye AS base

ENV GO_VERSION=1.24.3
ENV GO_SHA=a0afb9744c00648bafb1b90b4aba5bdb86f424f02f9275399ce0c20b93a2c3a8
