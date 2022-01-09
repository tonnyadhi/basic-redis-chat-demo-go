package config

import (
	_ "github.com/joho/godotenv/autoload"
	"os"
)

const (
	envNameServerAddress  = "SERVER_ADDRESS"
	envNameClientLocation = "CLIENT_LOCATION"
	envNameRedisAddress   = "REDIS_ADDRESS"
	envNameRedisPassword  = "REDIS_PASSWORD"

	defaultRedisAddress   = "0.0.0.0:6379"
	defaultServerAddress  = ":5000"
	defaultClientLocation = "/api/public"
)

type Config struct {
	ServerAddress  string
	ClientLocation string
	RedisAddress   string
	RedisPassword  string
}

func NewConfig() *Config {

	addr := os.Getenv(envNameServerAddress)
	if port := os.Getenv("PORT"); port != "" {
		addr = ":" + port
	}

	config := &Config{
		ServerAddress:  addr,
		ClientLocation: os.Getenv(envNameClientLocation),
		RedisAddress:   os.Getenv(envNameRedisAddress),
		RedisPassword:  os.Getenv(envNameRedisPassword),
	}
	if config.ServerAddress == "" {
		config.ServerAddress = defaultServerAddress
	}
	if config.ClientLocation == "" {
		config.ClientLocation = defaultClientLocation
	}
	if config.RedisAddress == "" {
		config.RedisAddress = defaultRedisAddress
	}

	return config
}
