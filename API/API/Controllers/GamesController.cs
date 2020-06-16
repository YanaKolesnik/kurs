using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using API.Filters;
using BasicAuthentication;

namespace BasicAuthentication.Controllers
{
    public class GamesController : ApiController
    {
        private articlesEntities db = new articlesEntities();

        [AllowAnonymous]
        // GET: api/Games
        public IQueryable<Games> GetGames()
        {
            return db.Games;
        }
        [AllowAnonymous]
        // GET: api/Games/5
        [ResponseType(typeof(GamesArticles))]
        public IHttpActionResult GetGamesArticles(int id)
        {
            GamesArticles gamesArticles = db.GamesArticles.Find(id);
            if (gamesArticles == null)
            {
                return NotFound();
            }

            return Ok(gamesArticles);
        }

        // PUT: api/Games/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutGames(int id, Games games)
        {
            if (id != games.ID)
            {
                return BadRequest();
            }

            string procedure = "";
            int number;
            string connectionString = @"Data Source=DESKTOP-RDKB255\SQLEXPRESS;Initial Catalog=articles;Integrated Security=True";
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                string commandStr =
                    $"EXEC GamesRating @id = '{games.ID}'," +
                    $" @rating = '{games.Rating}'";
                connection.Open();
                SqlCommand command = new SqlCommand(commandStr, connection);
                number = command.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                return BadRequest(ex.Message);
            }
            finally
            {
                connection.Close();
            }
            if (number != null)
                return Ok();

            return null;
        }

        // POST: api/Games
        [ResponseType(typeof(Games))]
        public IHttpActionResult PostGames(Games games)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.Games.Add(games);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (GamesExists(games.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = games.ID }, games);
        }

        // DELETE: api/Games/5
        [ResponseType(typeof(Games))]
        public IHttpActionResult DeleteGames(int id)
        {
            Games games = db.Games.Find(id);
            if (games == null)
            {
                return NotFound();
            }

            db.Games.Remove(games);
            db.SaveChanges();

            return Ok(games);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool GamesExists(int id)
        {
            return db.Games.Count(e => e.ID == id) > 0;
        }
    }
}