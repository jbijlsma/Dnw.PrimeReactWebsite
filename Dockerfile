FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
RUN apk add --update npm
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.csproj .
RUN dotnet restore

# copy everything else and build app
COPY . .
RUN dotnet publish -c release -o /app --self-contained false --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine
WORKDIR /app
COPY --from=build /app ./

# configure kestrel listening port
ENV ASPNETCORE_URLS=http://+:5050
ENV ASPNETCORE_ENVIRONMENT=Production

# this should be the entrypoint dll
ENTRYPOINT ["./Dnw.PrimeReactWebsite"]
