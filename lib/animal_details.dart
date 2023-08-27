import 'package:flutter/material.dart';

class AnimalDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Animal'),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text(
                'Detalhes',
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(height: 30),
              Image.asset(
                'assets/your_image.jpg', // Substituir pelo caminho da imagem
                width: 200,
                height: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              _buildDetailRow('Nome do Animal', 'Nome do animal aqui'),
              _buildDetailRow(
                  'Descrição do Animal', 'Descrição do animal aqui'),
              _buildDetailRow('Raça do Animal', 'Raça do animal aqui'),
              _buildDetailRow('Idade do Animal', 'Idade do animal aqui'),
              _buildDetailRow('Tamanho do Animal', 'Tamanho do animal aqui'),
              _buildDetailRow('Contato', 'Informações de contato aqui'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Ação do botão de voltar
                  Navigator.pop(context);
                },
                child: Text('Voltar'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
