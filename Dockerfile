FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

RUN groupadd -r tj && useradd -r -g tj tj

WORKDIR /app

RUN apt-get update

RUN curl - sL https://deb.nodesource.com/setup_16.x | bash -

RUN apt-get -y install nodejs

RUN chown -R tj:tj /app
COPY . ./

USER tj

RUN /home/tj/.dotnet

RUN dotnet restore

RUN dotnet build "dotnet6.csproj" -c Release

RUN dotnet publish "dotnet6.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 80
ENTRYPOINT ["dotnet", "dotnet6.dll"]