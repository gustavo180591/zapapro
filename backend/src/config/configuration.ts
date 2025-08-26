import { registerAs } from '@nestjs/config';

export default registerAs('config', () => ({
  nodeEnv: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT, 10) || 3001,
  
  // Database
  database: {
    url: process.env.DATABASE_URL,
  },
  
  // JWT
  jwt: {
    secret: process.env.JWT_SECRET,
    expiresIn: process.env.JWT_EXPIRES_IN || '1d',
    refreshSecret: process.env.JWT_REFRESH_SECRET,
    refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
  },
  
  // MercadoPago
  mercadoPago: {
    accessToken: process.env.MP_ACCESS_TOKEN,
    webhookSecret: process.env.MP_WEBHOOK_SECRET,
  },
  
  // AWS
  aws: {
    region: process.env.AWS_REGION,
    s3: {
      bucketName: process.env.AWS_S3_BUCKET_NAME,
    },
    sqs: {
      queueUrl: process.env.SQS_QUEUE_URL,
    },
    ses: {
      sender: process.env.SES_SENDER,
    },
  },
  
  // Google Maps
  googleMaps: {
    apiKey: process.env.GOOGLE_MAPS_API_KEY,
  },
  
  // WhatsApp
  whatsapp: {
    token: process.env.WHATSAPP_TOKEN,
  },
  
  // PostHog
  posthog: {
    key: process.env.POSTHOG_KEY,
  },
  
  // CORS
  cors: {
    origins: process.env.CORS_ORIGINS?.split(',') || '*',
  },
}));
