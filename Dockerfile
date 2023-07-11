FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

RUN groupadd -r tj && useradd -r -g tj tj

WORKDIR /app

RUN apt-get update

RUN curl - sL https://deb.nodesource.com/setup_16.x | bash -

RUN apt-get -y install nodejs

COPY . ./

RUN chown -R tj:tj /app

USER tj

RUN dotnet restore

RUN dotnet build "dotnet6.csproj" -c Release

RUN dotnet publish "dotnet6.csproj" -c Release -o publish

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base

RUN useradd -ms /bin/bash tj
EXPOSE 80
CMD ["dotnet","run"]