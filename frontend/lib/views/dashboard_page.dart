import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../models/medicion.dart';
import '../providers/theme_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();
    final medicion = viewModel.medicionActual;
    final historial = viewModel.historial;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Klimabewacher',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      body:
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : medicion == null
              ? const Center(child: Text('No hay datos disponibles'))
              : Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _compactCard(
                            context,
                            const Icon(Icons.thermostat),
                            'Temperatura',
                            '${medicion.temperatura.toStringAsFixed(1)} °C',
                          ),
                          _compactCard(
                            context,
                            const Icon(Icons.water_drop),
                            'Humedad',
                            '${medicion.humedad.toStringAsFixed(1)} %',
                          ),
                          _compactCard(
                            context,
                            const Icon(Icons.location_on),
                            'Ubicación',
                            medicion.ubicacion,
                          ),
                          _compactCard(
                            context,
                            const Icon(Icons.schedule),
                            'Última actualización',
                            medicion.fecha
                                .toLocal()
                                .toString()
                                .split(".")
                                .first,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      _graphSection(context, historial),
                      const SizedBox(height: 24),
                      Text(
                        'Histórico reciente',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            historial
                                .take(5)
                                .map((m) => _buildMiniCard(context, m))
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _compactCard(
    BuildContext context,
    Icon icon,
    String label,
    String value,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 20,
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              const SizedBox(height: 6),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _graphSection(BuildContext context, List<Medicion> historial) {
    final isWide = MediaQuery.of(context).size.width > 600;

    final temperatureData = historial.map((e) => e.temperatura).toList();
    final humidityData = historial.map((e) => e.humedad).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gráficas',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _graphCard(
                  context,
                  title: 'Temperatura (°C)',
                  color: Colors.deepOrange,
                  data: temperatureData,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _graphCard(
                  context,
                  title: 'Humedad (%)',
                  color: Colors.blue,
                  data: humidityData,
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              _graphCard(
                context,
                title: 'Temperatura (°C)',
                color: Colors.deepOrange,
                data: temperatureData,
              ),
              const SizedBox(height: 12),
              _graphCard(
                context,
                title: 'Humedad (%)',
                color: Colors.blue,
                data: humidityData,
              ),
            ],
          ),
      ],
    );
  }

  Widget _graphCard(
    BuildContext context, {
    required String title,
    required List<double> data,
    required Color color,
  }) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 280,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        interval: 1,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(),
                      left: BorderSide(),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots:
                          data
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value))
                              .toList(),
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniCard(BuildContext context, Medicion m) {
    return SizedBox(
      width: 150,
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${m.temperatura.toStringAsFixed(1)} °C / ${m.humedad.toStringAsFixed(1)} %',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                m.fecha.toLocal().toString().split(".").first,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
