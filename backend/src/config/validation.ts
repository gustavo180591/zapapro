import { plainToInstance } from 'class-transformer';
import { IsEnum, IsNumber, IsString, validateSync } from 'class-validator';

class EnvironmentVariables {
  @IsString()
  NODE_ENV: string;

  @IsNumber()
  PORT: number;

  @IsString()
  DATABASE_URL: string;

  @IsString()
  JWT_SECRET: string;

  @IsString()
  MP_ACCESS_TOKEN: string;

  @IsString()
  MP_WEBHOOK_SECRET: string;

  @IsString()
  AWS_REGION: string;

  @IsString()
  SQS_QUEUE_URL: string;

  @IsString()
  SES_SENDER: string;

  @IsString()
  GOOGLE_MAPS_API_KEY: string;

  @IsString()
  WHATSAPP_TOKEN: string;

  @IsString()
  POSTHOG_KEY: string;

  @IsString()
  CORS_ORIGINS: string;
}

export function validate(config: Record<string, unknown>) {
  const validatedConfig = plainToInstance(EnvironmentVariables, config, {
    enableImplicitConversion: true,
  });

  const errors = validateSync(validatedConfig, {
    skipMissingProperties: false,
  });

  if (errors.length > 0) {
    throw new Error(errors.toString());
  }
  
  return validatedConfig;
}
