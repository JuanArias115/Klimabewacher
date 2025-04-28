using KlimabewacherApi.Properties;
using Microsoft.EntityFrameworkCore;

namespace KlimabewacherApi.Context
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Medicion> Mediciones => Set<Medicion>();
    }
}
