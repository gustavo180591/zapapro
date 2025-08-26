import { Injectable, OnModuleInit, OnModuleDestroy, INestApplication } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  constructor() {
    super({
      log: ['error', 'warn'],
    });
  }

  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }

  async enableShutdownHooks(app: INestApplication) {
    this.$on('beforeExit', async () => {
      await app.close();
    });
  }

  async cleanDatabase() {
    if (process.env.NODE_ENV === 'production') return;
    
    const models = Reflect.ownKeys(this).filter((key) => 
      typeof key === 'string' && key[0] !== '_' && key[0] === key[0].toLowerCase()
    );

    return Promise.all(
      models.map((modelKey) => {
        if (modelKey === '$transaction' || modelKey === '$connect' || modelKey === '$disconnect') {
          return Promise.resolve();
        }
        return this[modelKey].deleteMany();
      }),
    );
  }
}
