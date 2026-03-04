# Na Mira do ENAM - Simulado

Simulado interativo para o ENAM (Exame Nacional da Magistratura).

## Estrutura

```
├── index.html              # Aplicação completa (single-page)
├── logo-na-mira.png        # Logo com fundo transparente
├── simulado-comentado.pdf  # PDF do simulado resolvido (download)
├── header_full.png         # Imagem header
├── img_p0_0.png            # Imagens das questões
├── img_p1_0.png
├── img_p2_0.png
└── supabase/
    └── migrations/
        ├── 001_create_simulado_schema.sql      # Schema base (questões, alternativas, simulados)
        ├── 002_seed_simulado_amostra.sql        # Dados de amostra
        ├── 003_create_simulado_results_schema.sql # Schema de resultados
        └── 004_add_whatsapp_column.sql          # Adicionar coluna WhatsApp
```

## Deploy

Hospedado na Vercel como site estático.

## Supabase - Migrations

Execute as migrations na ordem no SQL Editor do Supabase:

1. `001_create_simulado_schema.sql` - Cria tabelas de questões e simulados
2. `002_seed_simulado_amostra.sql` - Insere dados de amostra
3. `003_create_simulado_results_schema.sql` - Cria tabela de resultados
4. **`004_add_whatsapp_column.sql`** - Adiciona coluna `participant_whatsapp` na tabela `simulado_results`

> **IMPORTANTE:** A migration 004 deve ser executada para o campo WhatsApp funcionar corretamente.
