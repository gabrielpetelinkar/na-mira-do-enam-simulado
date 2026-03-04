-- ============================================
-- Migration: Adicionar coluna WhatsApp nos resultados
-- Projeto: Pedroaios (Coelho & Dias Cursos)
-- ============================================

-- Substituir campo position por whatsapp
ALTER TABLE simulado_results ADD COLUMN IF NOT EXISTS participant_whatsapp TEXT;

-- Indice para consultas por whatsapp
CREATE INDEX IF NOT EXISTS idx_simulado_results_whatsapp ON simulado_results(participant_whatsapp);
